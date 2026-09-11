--Le cancer
local s,id=GetID()
function s.initial_effect(c)
	--Traitée comme un Monstre Normal face recto sur le Terrain et dans le Cimetière
	--(sauf une fois passée chez l'adversaire via l'effet Gémeaux : là elle redevient Effet)
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

	--GÉMEAUX : Effet à Activer (une fois par tour) qui l'envoie chez l'adversaire
	--depuis ton terrain, où elle est déjà face recto
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.geminicon)
	e3:SetTarget(s.geminitg)
	e3:SetOperation(s.geminiop)
	c:RegisterEffect(e3)

	--Ne peut pas être sacrifiée pour une Invocation Sacrifice (tant que côté adverse)
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

--Traitée comme Normal seulement tant qu'elle n'a pas encore été "réinvoquée" chez l'adversaire
function s.normcon(e)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then return true end
	return c:IsFaceup() and c:GetOwner()==c:GetControler()
end

--Condition de l'effet Gémeaux : face recto, sous ton contrôle (donc pas déjà envoyée)
function s.geminicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetOwner()==tp and c:GetControler()==tp
end
function s.geminitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.geminiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetControler()==tp
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(c,tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	end
end

--Condition commune : contrôlée par quelqu'un d'autre que son propriétaire (= côté adverse)
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
