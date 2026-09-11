--JAIME PAS LIRE
local s,id=GetID()
function s.initial_effect(c)
    -- Définir le type de carte : Magie de Terrain + Magie
    c:SetType(TYPE_FIELD + TYPE_SPELL)
    c:SetProperty(PROPERTY_CONTINUOUS) -- Magie continue (pour rester active)

    -- Effet d'activation
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Fonction cible : Toujours activable (même sans monstre sur le terrain)
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end

-- Fonction d'activation : Annule les effets des monstres (sauf Extra Deck)
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        -- Vérifie si le monstre est invoqué depuis l'Extra Deck
        local isExtraDeckMonster = tc:IsSummonType(SUMMON_TYPE_FUSION)
            or tc:IsSummonType(SUMMON_TYPE_SYNCHRO)
            or tc:IsSummonType(SUMMON_TYPE_XYZ)
            or tc:IsSummonType(SUMMON_TYPE_LINK)
            or tc:IsSummonType(SUMMON_TYPE_PENDULUM)

        -- Si ce n'est PAS un monstre Extra Deck, on annule ses effets
        if not isExtraDeckMonster then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)

            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
        end
    end
end
