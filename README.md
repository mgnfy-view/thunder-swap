<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">Thunder Swap</h3>

  <p align="center">
    A decentralized exchange and flash swapping protocol
    <br />
    <a href="https://github.com/mgnfy-view/thunder-swap/blob/main/docs"><strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/mgnfy-view/thunder-swap/issues">Report Bug</a>
    ·
    <a href="https://github.com/mgnfy-view/thunder-swap/issues">Request Feature</a>
  </p>
</div>


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

Thunder Swap is a decentralized exchange protocol that also supports flash swaps. A flash swap allows you to get a certain amount of a type of token within the pool as loan, and swap it for a certain amount of the other type of token in the pool, plus some minimal fee.

A thunder swap pool factory is deployed on-chain, and users can interact with it to deploy thunder swap pools for supported tokens (set by the deployer). Liquidity providers can supply pools with liquidity and earn a fees of 0.3% on each swap. Each liquidity provider is minted LP (Liquidity Provider) tokens representing the portion of the pool they own. At any time, liquidity providers can exit the protocol by burning these LP tokens, which allows them to withdraw their liquidity along with any accrued fees.

Both normal swaps and flash swaps take place using the `ThunderSwapPool::flashSwapExactInput()` and `ThunderSwapPool::flashSwapExactOutput()` functions. In a normal swap, the `receiver` address is the user's wallet address; however, in a flash swap, a user sets the `receiver` address as the contract's address (which is `IThunderSwapReceiver` interface compliant). The contract that receives the token loan has to ensure that enough tokens are approved to the `ThunderSwapPool` when the control returns to it and the loan is paid back (along with fees). With flash swaps, contracts can also activate hooks before and after a swap to fine tune their swapping strategy.

Thunder Swap is marching towards a community-driven future with the introduction of the $THUD token, which is the key utility and governance token in the Thunder Swap ecosystem. Currently, the only way to obtain $THUD is via an airdrop conducted by the protocol team to reward loyal and regular users of the protocol. $THUD can be used to partake in governance, allowing the community to support more tokens on the exchange.

### Built With

- ![Foundry](https://img.shields.io/badge/-FOUNDRY-%23323330.svg?style=for-the-badge)
- ![Solidity](https://img.shields.io/badge/Solidity-%23363636.svg?style=for-the-badge&logo=solidity&logoColor=white)
- ![NPM](https://img.shields.io/badge/NPM-%23CB3837.svg?style=for-the-badge&logo=npm&logoColor=white)


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

Ensure that you have the Foundry framework installed on your system. You can get the installation instructions [here](https://book.getfoundry.sh/getting-started/installation).
Also, you'll need pnpm and make installed and configured on your system.

### Installation

Clone the repo

```shell
git clone https://github.com/mgnfy-view/thunder-swap
```

cd into the repo, and install the necessary dependencies

```shell
cd thunder-swap
make install
pnpm intall
```

That's it, you are good to go now!


<!-- ROADMAP -->
## Roadmap

- [x] Smart contract development
  - [x] Thunder Swap Core
  - [x] Thunder Swap $THUD token
  - [x] Thunder Swap Airdrop Manager
  - [x] Thunder Swap Governance
- [x] Testing
  - [x] Unit testing
    - [x] Pool deployment tests
    - [x] Liquidity tests
    - [x] Flash swap tests
    - [x] Airdrop tests
    - [x] Governance tests
    - [x] Miscellaneous tests
- [x] Write a deployment script
- [x] Write docs and README.md

See the [open issues](https://github.com/mgnfy-view/thunder-swap/issues) for a full list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.


<!-- CONTACT -->
## Reach Out

Here's a gateway to all my socials, don't forget to hit me up!

[![Linktree](https://img.shields.io/badge/linktree-1de9b6?style=for-the-badge&logo=linktree&logoColor=white)][linktree-url]


<!-- ACKNOWLEDGMENTS -->
<!-- ## Acknowledgments

* []()
* []()
* []() -->


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/mgnfy-view/thunder-swap.svg?style=for-the-badge
[contributors-url]: https://github.com/mgnfy-view/thunder-swap/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/mgnfy-view/thunder-swap.svg?style=for-the-badge
[forks-url]: https://github.com/mgnfy-view/thunder-swap/network/members
[stars-shield]: https://img.shields.io/github/stars/mgnfy-view/thunder-swap.svg?style=for-the-badge
[stars-url]: https://github.com/mgnfy-view/thunder-swap/stargazers
[issues-shield]: https://img.shields.io/github/issues/mgnfy-view/thunder-swap.svg?style=for-the-badge
[issues-url]: https://github.com/mgnfy-view/thunder-swap/issues
[license-shield]: https://img.shields.io/github/license/mgnfy-view/thunder-swap.svg?style=for-the-badge
[license-url]: https://github.com/mgnfy-view/thunder-swap/blob/main/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/sahil-gujrati-125ab0284
[linktree-url]: https://linktr.ee/mgnfy.view