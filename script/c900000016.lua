local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    
    -- Indestructible au combat
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    -- Annuler une carte sans réponse possible
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.distg)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanBeDisabledByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
    return tp==rp
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
    local g=Duel.SelectMatchingCard(tp,Card.IsCanBeDisabledByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    local tc=g:GetFirst()
    if tc then
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
