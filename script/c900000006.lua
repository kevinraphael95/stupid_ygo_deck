local s,id=GetID()
function s.initial_effect(c)
    -- Oblige le jeu à demander 2 sacrifices pour l'Invoquer
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(s.ttcon)
    e1:SetOperation(s.ttop)
    e1:SetValue(SUMMON_TYPE_TRIBUTE)
    c:RegisterEffect(e1)
end

function s.ttfilter(c)
    return c:IsReleasable()
end

function s.ttcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.ttfilter,tp,LOCATION_MZONE,0,nil)
    return minc<=2 and #g>=2 and Duel.GetMZoneCount(tp,g)>=1
end

function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(s.ttfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=g:Select(tp,2,2,nil)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
