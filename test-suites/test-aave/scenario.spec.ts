import { configuration as actionsConfiguration } from "./helpers/actions";
import { configuration as calculationsConfiguration } from "./helpers/utils/calculations";
import { evmRevert, evmSnapshot, DRE } from "../../helpers/misc-utils";

import fs from "fs";
import BigNumber from "bignumber.js";
import { makeSuite } from "./helpers/make-suite";
import { getReservesConfigByPool } from "../../helpers/configuration";
import {
  AavePools,
  iAavePoolAssets,
  IReserveParams,
} from "../../helpers/types";
import { executeStory } from "./helpers/scenario-engine";

// let buidlerevmSnapshotId: string = "0x1";
// const setBuidlerevmSnapshotId = (id: string) => {
//   buidlerevmSnapshotId = id;
// };

// const setSnapshot = async () => {
//   setBuidlerevmSnapshotId(await evmSnapshot());
// };

// const revertHead = async () => {
//   await evmRevert(buidlerevmSnapshotId);
// };

const scenarioFolder = "./test-suites/test-aave/helpers/scenarios/curve";

const selectedScenarios: string[] = [];

fs.readdirSync(scenarioFolder).forEach((file) => {
  if (selectedScenarios.length > 0 && !selectedScenarios.includes(file)) return;

  const scenario = require(`./helpers/scenarios/curve/${file}`);

  makeSuite(scenario.title, async (testEnv) => {
    //each file resets the state before moving on to the next file. I don't think each story within a file will revert state
    before("Initializing configuration", async () => {
      // Sets BigNumber for this suite, instead of globally
      BigNumber.config({
        DECIMAL_PLACES: 0,
        ROUNDING_MODE: BigNumber.ROUND_DOWN,
      });

      actionsConfiguration.skipIntegrityCheck = false; //set this to true to execute solidity-coverage

      calculationsConfiguration.reservesParams = <
        iAavePoolAssets<IReserveParams>
      >getReservesConfigByPool(AavePools.proto);
    });
    after("Reset", () => {
      // Reset BigNumber
      BigNumber.config({
        DECIMAL_PLACES: 20,
        ROUNDING_MODE: BigNumber.ROUND_HALF_UP,
      });
    });

    for (const story of scenario.stories) {
      it(story.description, async function () {
        // Retry the test scenarios up to 4 times if an error happens, due erratic HEVM network errors
        this.retries(4);
        await executeStory(story, testEnv);
      });
    }
  });
});
