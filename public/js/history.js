window.FHHistory = (function (window, document, undefined) {

	FHHistory = {

		_feed: (function () {
			return $('.history__log');
		})(),

		log: function (message, rollback) {
			var carr = $('<i class="history__undo">&crarr;</i>'),
				entry = $('<p class="history__entry"/>')
					.html(message)
					.append(carr);

			carr.click(function() {
				entry.remove();
				try {
					rollback();
				} catch(err) {
					console.error(err)
				}
			})

			this._feed.prepend(entry);
		}

	};

	return FHHistory;

})(this, this.document)