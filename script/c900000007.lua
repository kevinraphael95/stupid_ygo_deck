local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(s.condition)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    -- Déclenchable sur un effet mortel
    return rp~=tp
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc then
        Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
    end
    Duel.SkipPhase(1-tp,Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
end
