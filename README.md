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

# Documentation
## Add Exchanges
- Bitpapa: https://bitpapa.com/api/v1/pro/search?amount=10000&crypto_amount=107.53&type=sell&page=1&sort=price&currency_code=RUB&previous_currency_code=RUB&crypto_currency_code=USDT&with_correct_limits=false&limit=20&pages=10&total=190
- https://www.mexc.com/ru-RU
- https://docs.thorswap.finance/swapkit-docs/swapkit-api/swapkit-api/requesting-a-quote

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

## TODO
- Add DEX API? +1
- Add P2P/C2C from exists stocks
- Optimaze best_exchange with storing calculated node
- Write dotenv example to README
- Grade up to sinatra, postgres and puma.
- Use dry-rb datatypes for prices.
- Create auto-transfer using [BlockCypher](https://github.com/blockcypher/ruby-client)
