// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.8.0;

library DataTypes {
    struct CurveMetadata {
        uint256 _pid;
        uint8 _poolSize;
        address _curvePool;
        address _boosterAddr;
        bool isAllowed;
    }
    // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
    struct AssetData {
        uint8 underlyingAssetDecimals;
        string underlyingAssetName;
        string aTokenName; //needs to be unique per asset per tranche. This just provides the same name regardless of tranche, but user inputs the tranche so should give unique name in the end
        string aTokenSymbol;
        string variableDebtTokenName;
        string variableDebtTokenSymbol;
        string stableDebtTokenName;
        string stableDebtTokenSymbol;
        uint8 assetType;
        uint256 collateralCap;

        uint256 baseLTV;
        uint256 liquidationThreshold; //if this is zero, then disabled as collateral
        uint256 liquidationBonus;

        bool stableBorrowingEnabled;
        bool borrowingEnabled;

        bool isAllowed; //default to false, unless set
        //mapping(uint8=>address) interestRateStrategyAddress;//user must choose from this set list (index 0 is default)
        //the only difference between the different strategies is the value of the slopes and optimal utilization
        
    }

    // struct AssetDataConfiguration {
    // }

    struct InitReserveInput {
        // address aTokenImpl; //individual tranche users should not have control over this
        // address stableDebtTokenImpl;
        // address variableDebtTokenImpl;

        //choose asset, the other properties come with asset
        address underlyingAsset;

        //these can be chosen by user to be any address
        address treasury; 
        address incentivesController;

        uint8 interestRateChoice; //0 for default, others are undefined until set
        uint256 reserveFactor;
        bool forceDisabledBorrow; 
        bool forceDisabledCollateral; //even if we allow an asset to be collateral, pool admin can choose to force the asset to not be used as collateral in their tranche
    }

    struct InitReserveInputInternal {
        InitReserveInput input;
        uint64 trancheId;
        address aTokenImpl;
        address stableDebtTokenImpl;
        address variableDebtTokenImpl;
        AssetData assetdata;
    }

    enum ReserveAssetType {
        AAVE,
        CURVE
    } //update with other possible types of the underlying asset
    //AAVE is the original assets in the aave protocol
    //CURVE is the new LP tokens we are providing support for
    struct TrancheAddress {
        uint64 trancheId;
        address asset;
    }
    struct ReserveData {
        //stores the reserve configuration
        ReserveConfigurationMap configuration; //a lot of this is per asset rather than per reserve. But it's fine to keep since pretty gas efficient
        //these are for sure per reserve
        //the liquidity index. Expressed in ray
        uint128 liquidityIndex; //not used for nonlendable assets
        //variable borrow index. Expressed in ray
        uint128 variableBorrowIndex; //not used for nonlendable assets
        //the current supply rate. Expressed in ray
        uint128 currentLiquidityRate; //deposit APR is defined as liquidityRate / RAY //not used for nonlendable assets
        //the current variable borrow rate. Expressed in ray
        uint128 currentVariableBorrowRate; //not used for nonlendable assets
        //the current stable borrow rate. Expressed in ray
        uint128 currentStableBorrowRate; //not used for nonlendable assets
        uint40 lastUpdateTimestamp;
        //tokens addresses
        address aTokenAddress;
        address stableDebtTokenAddress; //not used for nonlendable assets
        address variableDebtTokenAddress; //not used for nonlendable assets
        //the id of the reserve. Represents the position in the list of the active reserves
        uint8 id;
        //maybe consider
        uint64 trancheId;
        address interestRateStrategyAddress;
    }

    // uint8 constant NUM_TRANCHES = 3;

    struct ReserveConfigurationMap {
        //bit 0-15: LTV
        //bit 16-31: Liq. threshold
        //bit 32-47: Liq. bonus
        //bit 48-55: Decimals

        //the above will not be set because they are properties of the asset as a whole
        //update: each reserve will have their own values. Just in case there needs to be a change, 
        //we can't set them all at the same time cause some reserves may satisfy the conditions but other reserves may not

        //update 2: we can just use the global version for ltv and liquidation bonus

        //bit 56: Reserve is active
        //bit 57: reserve is frozen
        //bit 58: borrowing is enabled
        //bit 59: stable rate borrowing enabled
        //bit 60-63: reserved
        //bit 64-79: reserve factor

        //bit 80-95: vmex reserve factor
        uint256 data;
    }

    struct UserConfigurationMap {
        uint256 data;
    }

    enum InterestRateMode {
        NONE,
        STABLE,
        VARIABLE
    }

    struct AcctTranche {
        address user;
        uint64 trancheId;
    }

    struct DepositVars {
        address asset;
        uint64 trancheId;
        address _addressesProvider;
        uint256 amount;
        address onBehalfOf;
        uint16 referralCode;
    }

    struct ExecuteBorrowParams {
        address asset;
        uint64 trancheId; //trancheId the user wants to borrow out of
        address user;
        address onBehalfOf;
        uint256 amount;
        uint256 interestRateMode;
        address aTokenAddress;
        uint16 referralCode;
        bool releaseUnderlying;
        uint256 _maxStableRateBorrowSizePercent;
        uint256 _reservesCount;
    }

    struct WithdrawParams {
        uint256 _reservesCount;
        address asset;
        uint64 trancheId;
        uint256 amount;
        address to;
    }

    struct calculateInterestRatesVars {
        address reserve;
        address aToken;
        uint256 liquidityAdded;
        uint256 liquidityTaken;
        uint256 totalStableDebt;
        uint256 totalVariableDebt;
        uint256 averageStableBorrowRate;
        uint256 reserveFactor;
        uint256 globalVMEXReserveFactor;
    }

    struct flashLoanVars {
        address receiverAddress;
        address[] assets;
        uint64 trancheId;
        uint256[] amounts;
        uint256[] modes;
        address onBehalfOf;
        bytes params;
        uint16 referralCode;
        uint256 _flashLoanPremiumTotal;
        address oracle;
        uint256 _maxStableRateBorrowSizePercent;
        address _addressesprovider;
        // mapping(uint8 => uint256) _reservesCount;
    }
}