// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/**
 * @title IBonded Token
 * @author DAOBox | (@pythonpete32)
 * @dev
 */
interface IBondedToken {
    function totalSupply() external view returns (uint256);
    function mint(address to, uint256 amount) external view returns (uint256);
    function burn(address from, uint256 amount) external view returns (uint256);
}
