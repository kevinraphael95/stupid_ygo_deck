--Le Cancer
local s,id=GetID()
function s.initial_effect(c)
	--Mécanisme Gémeaux natif du moteur : traité comme Normal Monster face recto
	--sur le Terrain/Cimetière, ET peut être Invoqué Normalement une 2e fois
	--(apparaît nativement comme option d'Invocation Normale dans le client)
	Gemini.AddProcedure(c)

	--Quand la 2e Invocation Normale (Gémeaux) réussit : donne le contrôle à l'adversaire
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.gemcon)
	e2:SetTarget(s.gemtg)
	e2:SetOperation(s.gemop)
	c:RegisterEffect(e2)

	--Ne peut pas être sacrifiée pour une Invocation Sacrifice (une fois en statut Gémeaux/Effet)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--Le PROPRIÉTAIRE perd 1000 LP à chacune de SES End Phases (une fois en statut Gémeaux/Effet)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE_START+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.lpcon)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
end

--Condition : la carte vient d'être Invoquée Normalement via son statut Gémeaux
function s.gemcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsGeminiSummoned()
end
function s.gemtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,1-tp,0)
end
function s.gemop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp,0,0)
	end
end

--Perte de LP du propriétaire à SA End Phase, seulement en statut Gémeaux/Effet
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Gemini.EffectStatusCondition(e) and Duel.GetTurnPlayer()==c:GetOwner()
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.LoseLP(c:GetOwner(),1000)
	end
end
