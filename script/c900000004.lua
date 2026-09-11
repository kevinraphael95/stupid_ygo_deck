local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- Invocation Spéciale quand un monstre est invoqué
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- Protection en position de défense
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.defcon)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetValue(aux.indoval)
    c:RegisterEffect(e4)

    -- Effet Rapide : Mélanger la main
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(s.handtg)
    e5:SetOperation(s.handop)
    c:RegisterEffect(e5)

    -- Retour en main si ciblé en position d'attaque
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BECOME_TARGET)
    e6:SetCondition(s.atkcon)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function s.defcon(e)
    return e:GetHandler():IsPosition(POS_DEFENSE)
end
function s.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 
        and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,LOCATION_HAND)
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
    local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
    if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
        Duel.ShuffleDeck(tp)
        Duel.ShuffleDeck(1-tp)
        Duel.Draw(tp,h1,REASON_EFFECT)
        Duel.Draw(1-tp,h2,REASON_EFFECT)
    end
end
function s.atkcon(e)
    return e:GetHandler():IsPosition(POS_ATTACK)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
    end
end
