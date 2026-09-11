-- Fusion au pif
-- Magie Rapide
-- Utilise 2 monstres Normaux depuis ta main et/ou ton terrain comme matériaux.
-- Invoque Fusion 1 monstre Fusion depuis ton Extra Deck qui partage un Attribut avec l'un des deux monstres sacrifiés.

local s, id = GetID()

function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Filtre : monstre Normal, en main ou face recto sur le terrain
function s.matfilter(c)
    return c:IsType(TYPE_NORMAL) and c:IsMonster() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()))
end

-- Filtre : monstre Fusion dans l'Extra Deck qui partage un Attribut avec au moins un des matériaux
function s.fusfilter(c, g)
    return c:IsType(TYPE_FUSION) and g:IsExists(Card.IsAttribute, 1, nil, c:GetAttribute())
end

-- Fonction pour vérifier si une paire de monstres permet d'invoquer un Fusion valide
function s.checkpair(g)
    return g:IsExists(function(c1)
        return g:IsExists(function(c2)
            if c1 == c2 then return false end
            local cg = Group.FromCards(c1, c2)
            return Duel.IsExistingMatchingCard(s.fusfilter, 0, LOCATION_EXTRA, 0, 1, nil, cg)
        end, 1, nil, nil)
    end, 1, nil, nil)
end

-- Ciblage : vérifie qu'il y a au moins 2 monstres Normaux et qu'une paire permet d'invoquer un Fusion valide
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local g = Duel.GetMatchingGroup(s.matfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, nil)
        if g:GetCount() < 2 then return false end
        return s.checkpair(g)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

-- Activation : sélection des matériaux, vérification, envoi au cimetière, invocation Fusion
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    -- Sélection des 2 monstres Normaux
    local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 2, 2, nil)
    if g:GetCount() ~= 2 then return end

    -- Vérifie qu'un monstre Fusion valide existe avec cette paire
    if not Duel.IsExistingMatchingCard(s.fusfilter, tp, LOCATION_EXTRA, 0, 1, nil, g) then return end

    -- Révèle les matériaux à l'adversaire
    Duel.ConfirmCards(1 - tp, g)

    -- Envoi des matériaux au cimetière
    Duel.SendtoGrave(g, REASON_FUSION + REASON_MATERIAL + REASON_EFFECT)
    Duel.BreakEffect()

    -- Sélection et invocation du monstre Fusion
    local fc = Duel.SelectMatchingCard(tp, s.fusfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, g):GetFirst()
    if fc then
        Duel.SpecialSummon(fc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
    end
end
