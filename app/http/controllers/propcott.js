var Propcott = require(app.models.propcott);

module.exports.view = (req, res) => {
	console.log(req.params.id);
	res.send('');
};

module.exports.remove = (req, res) => {
	res.send('');
};

module.exports.edit = (req, res) => {
	new Propcott({draftId: req.session.draftId}).load((err, propcott) => {
		res.render('propcott/create', {propcott: propcott});
	});
};

module.exports.join = (req, res) => {
	new User(req.session.user).support(req.params.id, err => {
		if(err) console.error(err);
		req.flash('Thank you for supporting this propcott!');
		res.redirect(`/p/${req.params.slug}`);
	});
};