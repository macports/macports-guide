$(function() {
	var testElement = $('#vh-test');
	testElement.css({ height: '100vh' });
	if (testElement.height() == window.innerHeight) {
		$('body').addClass('vh-supported');

		var stickyElement = $('div.toc');
		var stickyTop = stickyElement.offset().top;

		$(window).scroll(function() {
			var windowTop = $(window).scrollTop();

			if (stickyTop - 10 < windowTop) {
				if (stickyElement.css('position') != 'fixed') {
					stickyElement.css({ position: 'fixed', top: '10px' });
				}
			} else {
				if (stickyElement.css('position') != 'static') {
					stickyElement.css('position', 'static');
				}
			}
		});
	} else {
		$('body').addClass('vh-unuspported');
	}
});
