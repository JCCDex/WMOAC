# WMOAC

Wrapped MOAC

这是一个类似 [WETH](https://weth.io)的实现，因为在其他项目中需要，本以为 WETH 代码开源可以利用，实际上没有。

这个合约的作用很简单

1. 向本合约转账 deposit , 那么发行相同数量的 WMOAC
2. 要求提现 withdraw , 那么注销相同数量的 WMOAC

其他功能和 ERC20 完全一样，这么做的目的就是将 MOAC 和其他 ERC20 统一起来使用。

我们这个合约是利用了井畅开发的 ERC20Factory.sol，实际上部署时候，名称等都是作为参数提供的。

# 发布合约

```bash
jcc_moac_tool --config test --deploy build/contracts/WMOAC.json --gas_limit 3800000
```

# 基本信息

合约地址:
MOAC testnet : 0x5c837036509c9ab38494737cc1dfbee6eab6a5e2

multicall 合约
MOAC testnet : 0xc4b00992d186435fced593a691b7138b13971bc8

# 常用指令

```
 jcc_moac_tool --config config.test.json --abi build/contracts/WMOAC.json --contractAddr "0x5c837036509c9ab38494737cc1dfbee6eab6a5e2" --method "deposit" --amount "1.234" --gas_limit 98000

 jcc_moac_tool --config config.test.json --abi build/contracts/WMOAC.json --contractAddr "0x5c837036509c9ab38494737cc1dfbee6eab6a5e2" --method "withdraw"  --gas_limit 180000 --parameters 'chain3.toSha("0.1")'

 jcc_moac_tool --config ~/.jcc_moac_tool/config.venus.test.json --abi build/contracts/WMOAC.json --contractAddr "0x5c837036509c9ab38494737cc1dfbee6eab6a5e2" --method "balanceOf" --parameters '"地址"'

jcc_moac_tool --config ~/.jcc_moac_tool/config.venus.test.json --abi build/contracts/WMOAC.json --contractAddr "0x5c837036509c9ab38494737cc1dfbee6eab6a5e2" --method "balanceOf" --parameters '"地址"'

```
