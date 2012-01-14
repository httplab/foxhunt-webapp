window.FHMap = (function (window, document, undefined) {

	FHMap = {};

	// статичные поля
	$.extend(FHMap, {

		_map: (function () {
			YMaps.jQuery(function () {

				// создание карты с центром в Ростове-на-Дону
				var map = new YMaps.Map(YMaps.jQuery('#map')[0]);
				map.setCenter(new YMaps.GeoPoint(39.708225, 47.232075), 14);

				// добавление элементов управления
				map.enableScrollZoom();
				map.addControl(new YMaps.Zoom());
				map.addControl(new YMaps.TypeControl());
				map.addControl(new YMaps.ScaleLine());

				// кнопка добавления лисы на карту
				var addFox = new YMaps.ToolBarButton({
					icon: "http://api-maps.yandex.ru/i/0.4/placemarks/pmors.png",
					//caption: "Добавить лису",
					hint: "Добавляет лису в центр карты"
				});

				YMaps.Events.observe(addFox, addFox.Events.Click, function () {
					var center = map.getCenter(),
						name = prompt("Как назовем лису?"),
						fox;

					name && (fox = FHMap.drawFox({
						name: name,
						lat: center.__lat,
						lon: center.__lng
					}));

					FHHistory.log('!&nbsp;' + name, function() {
						FHMap._map.removeOverlay(fox)
					})
				}, map);


				var toolbar = new YMaps.ToolBar();
				toolbar.add(addFox);
				map.addControl(toolbar);

				FHMap._map = map;

				return map;
			})
		})(),

		FOXES_URL: 'examples/foxes'

	});

	//методы
	$.extend(FHMap, {

		getFoxes: function () {
			$.get(FHMap.FOXES_URL, function (data) {
				$.each(data, function () {
					FHMap.drawFox(this.fox)
				});
			}, 'json')
		},

		drawFox: function (fox) {
			if (!fox.lon || !fox.lat) return;

			var placemark = new YMaps.Placemark(new YMaps.GeoPoint(fox.lon, fox.lat), {
					draggable: true,
					style: 'default#redSmallPoint'
				}
			);

			// описание лисы внутри балуна
			$.extend(placemark, {
				name: fox.name,
				description: [
					'id: ' + fox.id || '',
					'lon: ' + fox.lon,
					'lat: ' + fox.lat
				].join("<br>")
			});

			placemark.setIconContent("<small>" + (fox.id || '') + "</small> " + fox.name);
			FHMap._map.addOverlay(placemark);

			// фиксируем новое положение лисы после перемещения её мышкой
			YMaps.Events.observe(placemark, placemark.Events.DragEnd, function (mark) {
				var point = mark.getGeoPoint();

				$.post(FHMap.FOXES_URL + "/" + fox.id, {
					name: fox.name,
					lat: point.__lat,
					lon: point.__lng
				}, function (data, status) {
					console.log(status)
				});

				FHHistory.log('&harr;&nbsp;' + fox.name, function () {
					if (!placemark._map) return

					placemark.setCoordPoint(new YMaps.GeoPoint(fox.lon, fox.lat));

					$.post(FHMap.FOXES_URL + "/" + fox.id, {
						name: fox.name,
						lat: fox.lat,
						lon: fox.lon,
					}, function (data, status) {
						console.log(status)
					});
				})
			});

			return placemark;

		},

		clearFoxes: function() {

			FHMap._map.removeAllOverlays();

		}
	});

	FHMap.getFoxes();

	return FHMap;

})(this, this.document)