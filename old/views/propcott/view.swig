{% extends '../base.swig' %}

{% block title %}propcott.title{% endblock %}

{% block body.end %}
	{% parent %}
	<div id="fb-root"></div>
	<script type="text/javascript" id="facebook-jssdk" src="//connect.facebook.net/en_US/sdk.js#xfbml=1&amp;version=v2.3&amp;appId=1475586926065669"></script>
	<script type="text/javascript" id="twitter-wjs" src="//platform.twitter.com/widgets.js"></script>
	<script type="text/javascript" src="/js/ZeroClipboard.js"></script>
	{% if user.id == propcott.creator.id %}
	<script type="text/javascript" src="/js/ckeditor/ckeditor.js"></script>
	{% endif %}
	<style>
	.cke_button__post_update .cke_button_icon {
		display: none;
	}
	.cke_button__post_update .cke_button_label {
		display: inline;
		padding: 0;
		font-weight: bold;
		cursor: pointer;
	}
	.cke_button__post_update {
		background-color: #e1edf7;
		transition: 300ms;
	}
	.cke_button__post_update:hover {
		background-color: #C7E3FA !important;
	}
	#cke_17 {
		float: right;
	}
	</style>
	<script type="text/javascript">
	var client = new ZeroClipboard( document.getElementById("copy-button") );
	client.on("ready", function(readyEvent) {
		var timeout, text;
		client.on("aftercopy", function(event) {
			if(timeout) timeout = clearTimeout(timeout), 0;
			else text = event.target.innerHTML;

			event.target.innerHTML = '<span class="typcn typcn-tick"></span>';

			timeout = setTimeout(function() {
				event.target.innerHTML = text;
			}, 1000);
		});
	});
	document.getElementById('propcott-new-update').placeholder = '<p>' + document.getElementById('propcott-new-update').placeholder + '</p>';

	CKEDITOR.plugins.add('post_update', {
		init: function(editor) {
			editor.addCommand('post_update', {
				exec: function(editor) {
					var form = document.createElement('form');
					form.method = 'POST';

					(function make(list) {
						for(var i in list) {
							var input = document.createElement('input');
							input.name = i;
							input.value = list[i];
							form.appendChild(input);
						}
					})({
						content: editor.getData(),
						action: 'update',
						'_token': '{{ csrf_token() }}'
					});

					document.body.appendChild(form);
					form.submit();
				}
			});

			editor.ui.addButton('post_update', {
				label: 'Post Update',
				command: 'post_update',
			});
		}
	});
	var editor = CKEDITOR.replace('propcott-new-update', {
		height: 'auto',
		extraPlugins: 'confighelper,post_update',
		title: ''
	}).on('change', function() {
		this.updateElement();
	});

	document.getElementById('propcott-updates-button').onclick = function() {
		var elem = document.getElementById('propcott-updates'), last;
		(function Scroll_To(elem, pos) {
			var y = elem.scrollTop;
			y += Math.round((pos - y) * 0.3);
			if (last == y || Math.abs(y-pos) < 2) {
				elem.scrollTop = pos;
				CKEDITOR.instances['propcott-new-update'].focus();
				return;
			}
			last = y;
			elem.scrollTop = y;
			setTimeout(Scroll_To, 40, elem, pos);
		})(document.body, elem.offsetTop);
	};
	</script>
	<style>
	#copy-button {
		width: 100px;
		text-align: center;
		float: right;
		border: 1px solid #ddd;
		background: #e7e7e7;
		padding: .5em;
		font-size: 1em;
		line-height: 1;
	}
	#copy-button span {
		font-size: 1em;
		line-height: 1;
	}
	#copy-link {
		text-size: .9em;
		background: white;
		padding: .5em;
		border: 1px solid #ddd;
		border-right: 0;
		line-height: 1;
		display: inline-block;
		overflow: hidden;
		display: block;
		white-space: nowrap;
	}
	#copy-label {
		float: left;
		display: inline-block;
		font-size: 1.5em;
		line-height: 1;
		padding: .166em;
	}
	#propcott-updates {
		background-color: white;
		box-shadow: 0 0 3px 1px rgba(0,0,0,0.2);
		margin-bottom: 1em;
		padding-bottom: 1px;
	}
	.propcott-update {
		border-top: 1px solid #eee;
		padding: 0 1em;
	}
	</style>
{% endblock %}

{% block content %}
<div class="container">
	{% if user.id == propcott.creator.id %}
	<div style="margin-top: .5em; padding: .5em; background: #eee; border: 1px solid #ddd; border-radius: 5px;">
		<form method="post">
			<button class="block" type="submit" name="action" value="edit">
				<span class="navigation-text">Edit Propcott</span>
				<span class="typcn typcn-pencil"></span>
			</button>
			<button class="block" type="submit" name="action" value="delete" onclick="return confirm('Are you sure you want to delete this propcott?');">
				<span class="navigation-text">Delete Propcott</span>
				<span class="typcn typcn-cancel"></span>
			</button>
			<button class="block" type="button" id="propcott-updates-button">
				<span class="navigation-text">Update Propcotters</span>
				<span class="typcn typcn-microphone"></span>
			</button>
			{% if !propcott.id %}
			<button class="block" type="submit" name="action" value="publish" onclick="return confirm('Are you sure you want to publish this propcott?');">
				<span class="navigation-text">Publish Propcott</span>
				<span class="typcn typcn-cloud-storage"></span>
			</button>
			{% endif %}
			{{ csrf_field() }}
		</form>
	</div>
	{% endif %}

	<div class="row">
		<div class="col-7 push-5">
			<div id="propcott" class="propcott-full">
				<div id="propcott-featured-image">
					<h1 style="font-size: {{ propcott.title_size }}">{{ propcott.title }}</h1>
				</div>
				<div id="propcott-content">
					{% if propcott.creator.displayName %}
					<p style="float: right; color: #aaa; margin: 0 1em; text-align: right; font-family: 'Josefin Sans',sans-serif; line-height: 1;">Propcott by {{ propcott.creator.displayName }}
					{% if propcott.creator.org %}<br>from
					{% if propcott.creator.org_link %}<a href="{{ propcott.creator.org_link.replace(/^(?!https?:\/\/)/, 'http://') }}">{{ propcott.creator.org }}{% else %}<strong style="color: #333;">{{ propcott.creator.org }}</strong>{% endif %}{% endif %}</a></p>
					{% endif %}

					<p style="margin: 1em;">Propcotting <span style="color: rgb(215,0,0);">{{ propcott.target }}</span></p>

					<hr />

					<h2 class="headline">Goal</h2>
					<p style="margin: 1em;">{{ propcott.what }}</p>

					<hr />

					<h2 class="headline">Why</h2>
					<div style="margin: 0 1em;">{{ propcott.why }}</div>
				</div>
			</div>
			{% if propcott.updates && propcott.updates.length && user.id == propcott.creator.id %}
				<div id="propcott-updates">
					{% if user.id == propcott.creator.id %}
						<textarea id="propcott-new-update"
							  name="propcott-new-update"
							  class="editable-region"
							  placeholder="Update your propcotters"
							  ></textarea>
					{% endif %}
					{% if propcott.updates && propcott.updates.length %}
						<h2 style="font-size: 1.2em; margin: 0; padding: 16px; border-top: 1px solid #eee;">Updates and Announcements</h2>
						{% for update in propcott.updates %}
							<div class="propcott-update{% if loop.index == 0 %} first{% endif %}">
							<div style="color: gray; float: right; font-size: .8em; margin: 0 0 1em 1em;">{{ update.created }}</div>
								{{ update.content }}
							</div>
						{% endfor %}
					{% endif %}
				</div>
			{% endif %}

			<div class="fb-comments" data-href="/p-test/{{ propcott.id }}" data-numposts="5"></div>
		</div>
		<div class="col-5 pull-7">
			<div id="propcott-sidebar">
				{% if propcott.media_type == 'image' %}
				<div id="propcott-media" style="background-image: url('http://static.propcott.com/{{ propcott.media_link }}');"></div>
				{% elseif propcott.media_type == 'video' %}
				<div id="propcott-media">
					<iframe style="width: 100%; height: 250px;" src="https://www.youtube.com/embed/{{ propcott.media_link }}" frameborder="0" allowfullscreen></iframe>
				</div>
				{% else %}
				<div id="propcott-media"></div>
				{% endif %}

				<div style="margin: .5em 1em 1em 0">
					{% if propcott.id %}
					<p style="float: right; font-weight: bold; font-family: 'Josefin Sans',sans-serif; vertical-align: top; color: rgb(215, 0, 0); margin: 0; line-height: 1;text-align: right; font-size: 1.2em; margin-top: -.5em;">{{ propcott.support }}<br><span style="font-weight: normal;">propcotters</span></p>
					{% endif %}

					<h2 style="font-size: 1.6em;margin: 1em 0 0 0;">Join <small>this propcott!</small></h2>

					<p style="margin-bottom: 0;">What to do:</p>

					<div class="list-wrapper">{{ propcott.how }}</div>

					{% if propcott.alt %}
						<p style="margin-bottom: 0;">Instead, you may want to try...</p>
						<div class="list-wrapper">{{ propcott.alt }}</div>
					{% endif %}

					{% if !user || user.supports.indexOf(propcott.id) == -1 %}
					<p>
						<form method="POST" action="/p/{{ propcott.id }}/join">
							<p style="font-family: 'Josefin Sans',sans-serif;line-height: 1;">
								<span style="font-weight: bold;">Were you a part of a campaign similar to this propcott in any way?</span>
								<label style="display: block;">
									<input type="radio" name="previous_support" value="1">
									I was already supporting a campaign similar to this propcott
								</label>
								<label style="display: block;">
									<input type="radio" name="previous_support" value="0">
									I was not, but now I proudly am.
								</label>
							</p>
							<button type="submit" class="block join-button">Join!</button>
							{{ csrf_field() }}
						</form>
					</p>
					{% else %}
						<p>
							<div class="fb-share-button" data-href="/p/{{ propcott.slug }}" data-layout="box_count" style="vertical-align: top;"></div>
							<a href="https://twitter.com/share" class="twitter-share-button" data-count="vertical" data-url="/p/{{ propcott.slug }}" data-text="{{ propcott.title }}" data-hashtags="propcott">Tweet</a>
						</p>
						<p>
							<span id="copy-label" class="typcn typcn-link"></span>
							<button id="copy-button" data-clipboard-text="/p/{{ propcott.slug }}">Copy link</button>
							<span id="copy-link">/p/{{ propcott.slug }}</span>
						</p>
					{% endif %}
				</div>
			</div>
		</div>
	</div>



</div>
{% endblock %}
