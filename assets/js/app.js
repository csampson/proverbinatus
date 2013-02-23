var QuoteEngine = {
  current_quote: {},
  init: function() {
    var blockquote = $('blockquote');

    this.paragraph = blockquote.find('p');
    this.citation = blockquote.find('cite');

    $.getJSON('/quotes', function(response) {
      QuoteEngine.quotes = response;
      QuoteEngine.update();
    });
  },
  getQuote: function() {
    var new_quote = this.quotes[Math.floor(Math.random() * this.quotes.length)];

    if(new_quote.text === this.current_quote.text)
      return this.getQuote();
    else
      return new_quote;
  },
  update: function() {
    this.current_quote = this.getQuote();

    this.transition(this.paragraph, this.current_quote.text);
    this.transition(this.citation, this.current_quote.citation);
  },
  // fade out, then fade back in, with new content
  transition: function(element, new_text) {
    element.stop().animate({opacity:0}, function() {
      $(this).html(new_text).animate({opacity:1});
    });
  }
};

$('#generate_quote').on('click', function() {
  QuoteEngine.update();
  _gaq.push(['_trackEvent', 'quotes', 'click', 'generate']);
});

QuoteEngine.init();
