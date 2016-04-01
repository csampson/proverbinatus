(function($, analytics) {
  'use strict';

  var QuoteEngine = {
    currentQuote: {},
    _getQuote: function() {
      var newQuote = this.quotes[Math.floor(Math.random() * this.quotes.length)];

      if(newQuote.text === this.currentQuote.text)
        return this._getQuote();
      else
        return newQuote;
    },
    // fade out, then fade back in, with new content
    _transition: function(element, newText) {
      element.stop().animate({ opacity: 0 }, function() {
        $(this).html(newText).animate({ opacity:1 });
      });
    },
    init: function() {
      this.quoteElement = $('.proverb-body');

      return $.getJSON('/quotes', function(response) {
        QuoteEngine.quotes = response;
        QuoteEngine.update();
      });
    },
    update: function() {
      this.currentQuote = this._getQuote();
      this._transition(this.quoteElement, this.currentQuote.text);

      return this;
    }
  };

  $('.proverb-generate').on('click', function() {
    QuoteEngine.update();
    analytics.push(['_trackEvent', 'quotes', 'click', 'generate']);
  });

  QuoteEngine.init();

})(window.jQuery, window._gaq);
