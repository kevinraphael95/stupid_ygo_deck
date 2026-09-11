local s,id=GetID()
function s.initial_effect(c)
    -- Statut Gémeaux (Normal sur le Terrain/Cimetière)
    aux.EnableGemini(c)

    -- Effet continu : Impossible de la sacrifier pour une Invocation Sacrifice
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UNRELEASABLE_SUMM)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    -- Effet quand elle devient un Monstre à Effet (Ré-invocation)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(aux.IsGeminiState)
    e2:SetTarget(s.morphtarget)
    e2:SetOperation(s.morphop)
    c:RegisterEffect(e2)

    -- Perte de 1000 LP à chaque End Phase du contrôleur actuel
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(s.lpcon)
    e3:SetOperation(s.lpop)
    c:RegisterEffect(e3)
end

-- Condition de ré-invocation vers le terrain adverse
function s.morphtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
end

function s.morphop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.GetControl(c,1-tp)
        Debug.Message("Le Cancer s'est propagé chez l'adversaire !")
    end
end

-- Perte de LP lors de la End Phase
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.IsGeminiState(e:GetHandler()) and Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.Hint(HINT_CARD,0,id)
        Duel.LoseLP(c:GetControler(),1000)
    end
end
