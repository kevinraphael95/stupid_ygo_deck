--JAIME PAS LIRE
local s,id=GetID()
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    for tc in aux.Next(g) do
        -- Vérifie si le monstre a été invoqué depuis l'Extra Deck
        local isExtraDeckMonster = tc:IsSummonType(SUMMON_TYPE_FUSION)
            or tc:IsSummonType(SUMMON_TYPE_SYNCHRO)
            or tc:IsSummonType(SUMMON_TYPE_XYZ)
            or tc:IsSummonType(SUMMON_TYPE_LINK)
            or tc:IsSummonType(SUMMON_TYPE_PENDULUM)

        -- Si ce n'est PAS un monstre invoqué depuis l'Extra Deck, on annule ses effets
        if not isExtraDeckMonster then
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_PHASE + PHASE_END)
            tc:RegisterEffect(e1)

            local e2 = Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_PHASE + PHASE_END)
            tc:RegisterEffect(e2)
        end
    end
end
