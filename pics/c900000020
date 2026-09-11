local s,id=GetID()
function s.initial_effect(c)
    -- Activation
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    -- Inversion d'attaque pour les monstres à effet (ils s'attaquent eux-mêmes)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    return a and a:IsType(TYPE_EFFECT)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    if not a or not a:IsRelateToBattle() then return end
    
    Duel.Hint(HINT_CARD,0,id)
    Debug.Message("C'est un monstre à effet ! Il refuse d'attaquer l'adversaire et t'attaque toi-même !")
    
    Duel.StopAttack()
    local damage=a:GetAttack()
    if damage>0 then
        Duel.Damage(a:GetControler(),damage,REASON_BATTLE)
    end
end
