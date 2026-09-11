--Le cancer
local s,id=GetID()
function s.initial_effect(c)
	--Traitée comme un Monstre Normal face recto sur le Terrain et dans le Cimetière
	--(sauf quand elle est sur le terrain adverse via cet effet : là elle redevient Effet)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(s.normcon)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)

	--Invocation Normale sur le terrain adverse
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.sumcon)
	e3:SetOperation(s.sumop)
	c:RegisterEffect(e3)

	--Ne peut pas être sacrifiée pour une Invocation Sacrifice (tant que sur le terrain adverse)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.effcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)

	--Le PROPRIÉTAIRE perd 1000 LP à chacune de SES End Phases
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE_START+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.lpcon)
	e5:SetOperation(s.lpop)
	c:RegisterEffect(e5)
end

--Condition "traitée comme Normal" : uniquement tant que sous le contrôle de son propriétaire
--(en GY, propriétaire = contrôleur de fait, donc toujours vrai là-bas)
function s.normcon(e)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then return true end
	return c:IsFaceup() and c:GetOwner()==c:GetControler()
end

--Invocation Normale procédurale vers le terrain adverse
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetStatus(STATUS_SUMMONED_ATTACK,true)
	Duel.MoveToField(c,tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
end

--Condition commune : la carte est sur le terrain, contrôlée par quelqu'un d'autre que son propriétaire
function s.effcon(e)
	local c=e:GetHandler()
	return c:GetOwner()~=c:GetControler()
end

--Perte de LP du propriétaire à SA End Phase
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return s.effcon(e) and Duel.GetTurnPlayer()==c:GetOwner()
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.LoseLP(c:GetOwner(),1000)
	end
end
