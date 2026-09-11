local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Immunité contre FEU et VENT
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(s.efilter)
    c:RegisterEffect(e1)

    -- Attaquer à nouveau après avoir attaqué FEU ou VENT
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLED)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
function s.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsAttribute(ATTRIBUTE_FIRE) or te:GetHandler():IsAttribute(ATTRIBUTE_WIND))
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and (bc:IsAttribute(ATTRIBUTE_FIRE) or bc:IsAttribute(ATTRIBUTE_WIND)) and c:CanChainAttack()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end
