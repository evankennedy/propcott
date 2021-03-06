var c = require(app.http.controllers.index);
var m = require(app.http.middleware.index);

var Propcott = require(app.models.propcott);
var User = require(app.models.user);

module.exports = function(app) {
	['about', 'contact', 'privacy', 'terms', 'creator-tips', 'supporter-tips'].forEach(page => {
		app.get(`/${page}`, (req, res) => res.render(`static/${page}`));
	});
	
	app.post('/contact', c.contact);

	app.get ('/', c.home);
	app.get ('/search', c.search.cse);

	app.get ('/explore', c.explore.recent);
	app.get ('/explore/all', c.explore.all);
	app.get ('/explore/daily', c.explore.daily);
	app.get ('/explore/weekly', c.explore.weekly);
	app.get ('/explore/monthly', c.explore.monthly);
	
	app.get ('/login',    m.guest, c.auth.form);
	app.post('/login',    m.guest, c.auth.login);
	app.get ('/logout',   m.user,  c.auth.logout);

	app.get ('/oauth/facebook',          c.oauth.connect);
	app.post('/oauth/facebook',          c.oauth.connect);
	app.get ('/oauth/facebook/callback', c.oauth.callback);

	app.get ('/account', m.user, c.account.general);
	app.post('/account', m.user, c.account.updateGeneral);
	app.get ('/account/propcotts',     m.user, c.account.propcotts);
	app.get ('/account/notifications', m.user, c.account.notifications);
	app.post('/account/notifications', m.user, c.account.notifications);
	app.get ('/account/notifications/unsubscribe', m.userR, c.account.unsubscribe);

	app.post('/api/upload', c.api.upload);

	app.get ('/d/:draft_id',         m.userR, m.ownDraft, c.draft.view);
	app.get ('/d/:draft_id/edit',    m.userR, m.ownDraft, c.draft.edit);
	app.get ('/d/:draft_id/delete',  m.userR, m.ownDraft, c.draft.remove);
	app.get ('/d/:draft_id/publish', m.userR, m.ownDraft, c.draft.publish);

//	app.get ('/v/:slug',                 m.ownDraft, c.propcott.view);
	app.get ('/p/:slug',                 m.slugToId, c.propcott.view);
	app.get ('/p/:slug/edit',   m.userR, m.slugToId, c.propcott.edit);
	app.post('/p/:slug/update', m.userR, m.slugToId, c.propcott.update);
//	app.get ('/p/:slug/delete', m.userR, m.slugToId, c.propcott.remove);
	app.get ('/p/:slug/join',   m.slugToId, c.propcott.join);
	app.post('/p/:slug/join',   m.slugToId, c.propcott.join);

	app.get ('/new',                     c.editor.fresh);
	app.get ('/editor',                  c.editor.edit);
	app.get ('/editor/preview',          c.editor.preview);
	app.get ('/editor/cancel',           c.editor.cancel);
	app.get ('/editor/save',    m.userR, c.editor.save);
	app.post('/editor/handle',           c.editor.handle);

	/*
	|--------------------------------------------------------------------------
	| Handle Actions
	|--------------------------------------------------------------------------
	|
	| save		(id) ? update propcott : create propcott from draft
	| 			redirect to draft or published propcott
	|
	| preview	update draft
	| 			redirect to preview
	|
	| cancel	cancel current draft
	| 			redirect to (id) ? propcott : homepage
	*/
};
