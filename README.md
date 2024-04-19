# Crypto Graph
This project using [graph deep first search with colors](https://neerc.ifmo.ru/wiki/index.php?title=%D0%9E%D0%B1%D1%85%D0%BE%D0%B4_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83,_%D1%86%D0%B2%D0%B5%D1%82%D0%B0_%D0%B2%D0%B5%D1%80%D1%88%D0%B8%D0%BD) algorithm for best exchange search.

# Quick Start
```
git clone git@github.com:Senchatay/crypto_graph.git
cd crypto_graph
bundle
ruby app/main.rb
```

# Done
- [x] Create full loop for finding profit cycle.
- [x] Calculate cost with blockchain-system comission.
- [x] Sort results by profit and show only top.

# TODO
- Dockerize app.
- Grade up to sinatra, postgres and puma.
- Parse realtime blockchain-system comission.
- Parse realtime exchange.
- Use dry-rb datatypes for prices.
- Create smart-contract using solidity.
