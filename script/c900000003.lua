-- J'aime pas ce que je comprend pas (les pendules)
local s,id=GetID()
function s.initial_effect(c)
    -- Effet sur le terrain
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    
    -- Effet depuis le Cimetière
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)
end
function s.penfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(s.penfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.penfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
