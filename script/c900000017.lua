local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Invocation Synchro
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.syncon)
    e1:SetOperation(s.synop)
    c:RegisterEffect(e1)

    -- Quand la carte quitte le terrain
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetOperation(s.leaveop)
    c:RegisterEffect(e2)

    -- Effet Cimetière (Piocher)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(aux.bfgcost)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
function s.syncon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
    local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil):RandomSelect(tp,1)
    local g3=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil):RandomSelect(tp,1)
    g1:Merge(g2)
    g1:Merge(g3)
    if #g1>0 then
        Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
    end
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
    local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil):RandomSelect(tp,1)
    g1:Merge(g2)
    if #g1>0 then
        Duel.SendtoGrave(g1,REASON_EFFECT)
    end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_REMOVED,nil)
    if ct>0 then
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end
