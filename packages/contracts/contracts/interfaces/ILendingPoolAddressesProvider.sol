// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.19;

import {DataTypes} from "../protocol/libraries/types/DataTypes.sol";

/**
 * @title LendingPoolAddressesProvider contract
 * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
 * - Acting also as factory of proxies and admin of those, so with right to change its implementations
 * - Owned by the Aave Governance
 * @author Aave
 **/
interface ILendingPoolAddressesProvider {
    event MarketIdSet(string newMarketId);
    event LendingPoolUpdated(address indexed newAddress);

    // event ATokensAndRatesHelperUpdated(address indexed newAddress);
    event ConfigurationAdminUpdated(
        address indexed newAddress,
        uint64 indexed trancheId
    );
    event EmergencyAdminUpdated(address indexed newAddress);
    event LendingPoolConfiguratorUpdated(address indexed newAddress);
    event LendingPoolCollateralManagerUpdated(address indexed newAddress);
    event PriceOracleUpdated(address indexed newAddress);
    event CurvePriceOracleUpdated(address indexed newAddress);
    event CurvePriceOracleWrapperUpdated(address indexed newAddress);
    event CurveAddressProviderUpdated(address indexed newAddress);
    event ProxyCreated(bytes32 id, address indexed newAddress);
    event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);


    event VMEXTreasuryUpdated(address indexed newAddress);
    event AssetMappingsUpdated(address indexed newAddress);


    event ATokenUpdated(address indexed newAddress);
    event ATokenBeaconUpdated(address indexed newAddress);
    event VariableDebtUpdated(address indexed newAddress);
    event VariableDebtBeaconUpdated(address indexed newAddress);

    event IncentivesControllerUpdated(address indexed newAddress);

    event PermissionlessTranchesEnabled(bool enabled);

    event WhitelistedAddressesSet(address indexed user, bool whitelisted);

    function getVMEXTreasury() external view returns(address);

    function setVMEXTreasury(address add) external payable;

    function getMarketId() external view returns (string memory);

    function setMarketId(string calldata marketId) external payable;

    function setAddress(bytes32 id, address newAddress) external payable;

    function setAddressAsProxy(bytes32 id, address impl) external payable;

    function getAddress(bytes32 id) external view returns (address);

    function getLendingPool() external view returns (address);

    function setLendingPoolImpl(address pool) external payable;

    function getLendingPoolConfigurator() external view returns (address);

    function setLendingPoolConfiguratorImpl(address configurator) external payable;

    function getLendingPoolCollateralManager() external view returns (address);

    function setLendingPoolCollateralManager(address manager) external payable;

    //********************************************************** */

    function getGlobalAdmin() external view returns (address);

    function setGlobalAdmin(address admin) external payable;

    function getTrancheAdmin(uint64 trancheId) external view returns (address);

    function setTrancheAdmin(address admin, uint64 trancheId) external;

    function addTrancheAdmin(address admin, uint64 trancheId) external;

    function getEmergencyAdmin()
        external
        view
        returns (address);

    function setEmergencyAdmin(address admin) external payable;

    function isWhitelistedAddress(address ad) external view returns (bool);

    //********************************************************** */
    function getPriceOracle()
        external
        view
        returns (address);

    function setPriceOracle(address priceOracle) external payable;

    function getAToken() external view returns (address);
    function setATokenImpl(address pool) external payable;

    function getATokenBeacon() external view returns (address);
    function setATokenBeacon(address pool) external payable;

    function getVariableDebtToken() external view returns (address);
    function setVariableDebtToken(address pool) external payable;

    function getVariableDebtTokenBeacon() external view returns (address);
    function setVariableDebtTokenBeacon(address pool) external payable;

    function getAssetMappings() external view returns (address);
    function setAssetMappingsImpl(address pool) external payable;

    function getIncentivesController() external view returns (address);
    function setIncentivesController(address incentives) external payable;
}
