# WMOAC

Wrapped MOAC

这是一个类似 [WETH](https://weth.io)的实现，因为在其他项目中需要，本以为 WETH 代码开源可以利用，实际上没有。

这个合约的作用很简单

1. 向本合约转账 deposit , 那么发行相同数量的 WMOAC
2. 要求提现 withdraw , 那么注销相同数量的 WMOAC

其他功能和 ERC20 完全一样，这么做的目的就是将 MOAC 和其他 ERC20 统一起来使用。

我们这个合约是利用了井畅开发的 ERC20Factory.sol，实际上部署时候，名称等都是作为参数提供的。

# 发布合约

# 基本信息
