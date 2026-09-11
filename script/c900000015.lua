local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.mfilter(c)
    return c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_MZONE))
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
        return #mg>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
    if #mg<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FUSMATERIAL)
    local mat=mg:Select(tp,2,2,nil)
    if #mat==2 then
        local tc1=mat:GetFirst()
        local tc2=mat:GetNext()
        local att1=tc1:GetAttribute()
        local att2=tc2:GetAttribute()
        local fg=Duel.GetMatchingGroup(function(c)
            return c:IsType(TYPE_FUSION) and (c:IsAttribute(att1) or c:IsAttribute(att2)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
        end,tp,LOCATION_EXTRA,0,nil)
        if #fg>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tc=fg:Select(tp,1,1,nil):GetFirst()
            Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        end
    end
end
