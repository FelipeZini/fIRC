Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '226193220755732', 'f81feded44e16de033af47e4fcdb676c'
end
