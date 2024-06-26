# Crypto Graph
Crypto Graph is crypto-currency price aggregator.

This project using [graph deep first search with colors](https://neerc.ifmo.ru/wiki/index.php?title=%D0%9E%D0%B1%D1%85%D0%BE%D0%B4_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83,_%D1%86%D0%B2%D0%B5%D1%82%D0%B0_%D0%B2%D0%B5%D1%80%D1%88%D0%B8%D0%BD) algorithm for best exchange search.

# Quick Start
```
git clone git@github.com:Senchatay/crypto_graph.git
cd crypto_graph
make build
make start
cat tmp/result.txt
```

## Commands
```
make build          # Build the image
make start          # Start Container and compute calculation
make debug          # Run Container in debug mode
```

## ENV example
```sh
# .env
ETHERSCAN_API_KEY = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
TRONSCAN_API_KEY = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
BYBIT_API_KEY = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
BYBIT_API_SECRET = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
SIMPLE_SWAP_API_KEY = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
CHANGE_NOW_API_KEY = '50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
1INCH_API_KEY = 'Bearer 50d858e0985ecc7f60418aaf0cc5ab587f42c2570a884095a9e8ccacd0f6545c'
```

# Documentation
## Helpful info
- https://medium.com/@rahul_m/tor-with-ruby-to-make-anonymous-request-b52f266f8f6b

## Done
- [x] Create full loop for finding profit cycle.
- [x] Calculate cost with blockchain-system commission.
- [x] Sort results by profit and show only top.
- [x] Dockerize app.
- [x] Parse realtime blockchain-system commission.
- [x] Parse realtime exchange.
- [x] Optimaze best_change API for rates(600k many times select)
- [x] Add DEX API? +1
- [x] Add P2P/C2C from exists stocks
- [x] Write dotenv example to README

## TODO
- Optimaze best_exchange with storing calculated node
- Grade up to sinatra, postgres and puma.
- Use dry-rb datatypes for prices.
- Create auto-transfer using [BlockCypher](https://github.com/blockcypher/ruby-client)
