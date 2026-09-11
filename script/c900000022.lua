local s,id=GetID()
function s.initial_effect(c)
    -- Traité comme un Monstre Normal sur le Terrain et dans le Cimetière
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(TYPE_NORMAL)
    c:RegisterEffect(e1)
    
    local e2=e1:Clone()
    e2:SetCode(EFFECT_REMOVE_TYPE)
    e2:SetValue(TYPE_EFFECT)
    c:RegisterEffect(e2)

    -- Invocation Normale spéciale sur le terrain adverse
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(s.sumcon)
    e3:SetOperation(s.sumop)
    c:RegisterEffect(e3)

    -- Effet continu : Ne peut pas être sacrifié pour une Invocation Sacrifice
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUMM)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.effcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)

    -- Le contrôleur actuel perd 1000 LP à sa End Phase
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(s.lpcon)
    e5:SetOperation(s.lpop)
    c:RegisterEffect(e5)
end

function s.sumcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return minc==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
    c:SetStatus(STATUS_SUMMONED_ATTACK,true)
    Duel.MoveToField(c,tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.effcon(e)
    return e:GetHandler():GetFlagEffect(id)>0
end

function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return s.effcon(e) and Duel.GetTurnPlayer()==c:GetControler()
end

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.LoseLP(c:GetControler(),1000)
    end
end
