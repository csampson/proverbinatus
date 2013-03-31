Proverbinatus
=============

Proverbinatus is a sinatra app to show and fetch Warhammer 40k proverbs('Thought for the day').

Quotes/proverbs are stored as JSON in a flat manner, with the following keys:
- `text` the actual quote text
- `citation` source of the quote
- `topics` themes of the proverb(e.g, 'hatred')


Proverbinatus provides a frontend for showing and fetching random quotes, as well as paths to fetch quotes:
- `/quotes` returns an array of all quotes(as JSON)
- `/quotes/random` returns a random quote as plain text(try this: `curl http://proverbinatus.com/quotes/random/; echo`)
- `/quotes/random/:topic` returns a random quote matching the topic param
