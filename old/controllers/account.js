var User = local('models/user');

module.exports.updateGeneral = function(req, res, next) {
	if(!req.session.user) return next();

	var user = new User({id: req.session.user.id});
	user.load(function(err, user) {
		if(err) {
			req.flash('Could not update account');
			res.redirect('/account');
			return;
		}

		delete user['g-recaptcha-response'];
		if(req.body.password && req.body.password != req.body.password_verify) {
			req.flash('Passwords do not match');
			res.redirect('/account');
			return;
		}
		if(req.body.password) {
			user.unlink('local', user.email);
			user.link('local', req.body.email || user.email, req.body.password);
		} else if(req.body.email) {
			user.relink('local', user.email, req.body.email);
		}

		delete req.body.password;
		delete req.body.password_verify;

		for(var i in req.body) user[i] = req.body[i];

		user.save(function(err, user) {
			if(err)
				req.flash('Could not update account');
			else
				req.flash('Account updated successfully');
			res.render('account/general', {user: user});
		});
	});
/*	$this->validate($request, [
		'email' => 'email',
	]);

	var user = req.session.user;

	foreach(['name', 'display_name', 'email', 'zip', 'gender', 'org', 'org_link'] as $prop)
		$user->{$prop} = $request->{$prop};

	if($request->has('birth-month') && $request->has('birth-year')) $user->birthday = date("Y-m-d", mktime(0, 0, 0, $request->get('birth-month') , 1, $request->get('birth-year')));

	user.save();
	req.flash('Account updated successfully!');*/
};

module.exports.general = function(req, res) {
	if(!req.session.user) return next();

	var user = new User(req.session.user.id);
	user.load(function(err, user) {
		if(err) {
			req.flash('Could not load account info');
			res.redirect('/');
			return;
		}
		res.render('account/general', {user: user});
	});
};

module.exports.propcotts = function() {

};

module.exports.notifications = function() {

};

module.exports.connections = function() {

};

