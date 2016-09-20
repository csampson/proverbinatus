### Proverbinatus

## Overview

An app to display and fetch [Warhammer 40,000](http://en.wikipedia.org/wiki/Warhammer_40,000) proverbs (an Imperial 'Thought for the day').

## The Stack

`sinatra` - web framework   
`thin` - web server   
`sprockets` - static asset middleware   
`rmagick` - image generation/manipulation library   
`rspec` - BDD testing framework

## Data Storage

Proverbs are stored as JSON in a flat manner, with the following keys:
- `text` the actual quote text
- `citation` source of the quote
- `topics` themes of the proverb(e.g, 'hatred')

## API

- `/quotes` returns an array of all quotes(as JSON)
- `/quotes/random` returns a random quote as plain text(try this: `curl http://proverbinatus.com/quotes/random/; echo`)
- `/quotes/random/:topic` returns a random quote matching the topic param
- `/generate-image/taylor_swift` returns an image of Taylor Swift with a provreb embedded within

---

<img src='http://proverbinatus.com/generate-image/taylor_swift' alt='' />
