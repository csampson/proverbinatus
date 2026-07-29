(function($, analytics) {
  'use strict';

  var QuoteEngine = {
    currentQuote: {},
    deck: [],
    // Fisher-Yates shuffle
    _shuffle: function(quotes) {
      for(var i = quotes.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = quotes[i];
        quotes[i] = quotes[j];
        quotes[j] = temp;
      }
      return quotes;
    },
    _refillDeck: function() {
      this.deck = this._shuffle(this.quotes.slice());

      // avoid repeating the quote that was just shown across the reshuffle
      if(this.deck.length > 1 && this.deck[0].text === this.currentQuote.text) {
        this.deck.push(this.deck.shift());
      }
    },
    _getQuote: function() {
      if(this.deck.length === 0)
        this._refillDeck();

      return this.deck.shift();
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
