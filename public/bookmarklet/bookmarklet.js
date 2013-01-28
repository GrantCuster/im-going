(function(){

	// the minimum version of jQuery we want
	var v = "1.3.2";

	// check prior inclusion and version
	if (window.jQuery === undefined || window.jQuery.fn.jquery < v) {
		var done = false;
		var script = document.createElement("script");
		script.src = "http://ajax.googleapis.com/ajax/libs/jquery/" + v + "/jquery.min.js";
		script.onload = script.onreadystatechange = function(){
			if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {
				done = true;
				initMyBookmarklet();
			}
		};
		document.getElementsByTagName("head")[0].appendChild(script);
	} else {
		initMyBookmarklet();
	}
	
	function initMyBookmarklet() {
		(window.myBookmarklet = function() {
			var domain = document.location.hostname.toString();
			var $page = $(document);
			var goingframe = document.createElement('iframe');
			goingframe.setAttribute('src','http://going.im/bookmarklet');
			goingframe.setAttribute('style','position: fixed; z-index: 99999; width: 400px; height: 100%; right: 0; top: 0; border-left: solid 1px #bfbfbf;');
			document.body.appendChild(goingframe);
			$page.find('body').append('<div id="going-toggle-sidebar" style="cursor: pointer; width: 35px; height: 40px; background: #bfbfbf; position: fixed; right: 400px; top: 0; z-index: 99999;"><div id="going-toggle-triangle" style="border: solid 10px transparent; position: absolute; left: 14px; top: 9px; border-left-color: #333;"></div></div>');
			if (domain == "www.ticketfly.com") {
				var event_name = $page.find('.event-name').text().trim();
				var day = $page.find('#when').text().trim();
				var hour = $page.find('.time').text().trim();
				var venue = $page.find('.venue').text().trim();
				var location = $page.find('.location').text().trim();
				var price = $page.find('#price-range').text().trim();
				var url = domain + document.location.pathname;
			}
			$('#going-toggle-sidebar').click(function() {
				if ($(this).hasClass('collapsed')) {
					$(goingframe).css('width',400);
					$(this).removeClass('collapsed').css('right','400px').find('#going-toggle-triangle').css({
						'border-left-color' : '#333',
						'border-right-color' : 'transparent',
						'left' : '14px'
					});
				} else {
					$(goingframe).css('width',0)
					$(this).addClass('collapsed').css('right','0px').find('#going-toggle-triangle').css({
						'border-left-color' : 'transparent',
						'border-right-color' :'#333',
						'left' : '1px'
					});
				}
			});
			window.addEventListener("message", function(e){
				var message = e.data;
				var fired = false;
				if (message == "initialize") {
					if (fired == false) {
						var msg = {};
						msg.toggle = true
						msg.event_name = event_name;
						msg.day = day;
						msg.hour = hour;
						msg.venue = venue;
						msg.location = location;
						msg.price = price;
						msg.url = url;
						goingframe.contentWindow.postMessage(msg,'*')
						fired = true;
					}
				}
			});
		})();
	}

})();