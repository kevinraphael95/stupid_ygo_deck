local s,id=GetID()
function s.initial_effect(c)
    -- Activation
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Condition : Contrôler un monstre Normal avec 3000 ATK ou plus
function s.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:GetAttack()>=3000
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp)
    local opp_monsters=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    if chkc then return false end
    if chkc==nil then
        e:SetLabel(math.floor(opp_monsters/2))
        return opp_monsters>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
    end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- 1. Destruction de la moitié des monstres sur le terrain adverse (min. 1, arrondi à l'inférieur)
    local g=Duel.GetMatchingGroup(Card.IsMonster,tp,0,LOCATION_MZONE,nil)
    local count=#g
    if count>0 then
        local destroy_count=math.floor(count/2)
        if destroy_count==0 then destroy_count=1 end -- min. 1
        
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,destroy_count,destroy_count,nil)
        Duel.Destroy(sg,REASON_EFFECT)
    end

    -- 2. L'adversaire envoie la moitié de ses monstres de son deck au cimetière (il choisit)
    local deck_monsters=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
    local deck_count=#deck_monsters
    if deck_count>0 then
        local send_count=math.floor(deck_count/2)
        if send_count>0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
            local sg_deck=deck_monsters:Select(1-tp,send_count,send_count,nil)
            Duel.SendtoGrave(sg_deck,REASON_EFFECT)
        end
    end
end
