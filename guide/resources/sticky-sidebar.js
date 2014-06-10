$(function() {
	var stickyTop = $('div.toc').offset().top;

	$(window).scroll(function() {
		var windowTop = $(window).scrollTop();

		if (stickyTop - 10 < windowTop) {
			$('div.toc').css({ position: 'fixed', top: '10px' });
		} else {
			$('div.toc').css('position', 'static');
		}
	});
});
