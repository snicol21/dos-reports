require("dotenv").config()
const shell = require("node-powershell")

let ps = new shell({
  verbose: true,
  executionPolicy: "Unrestricted",
  noProfile: true,
})

ps.addCommand("./scripts/deploy.ps1")
  .then(() => {
    ps.addParameters([
      { name: "secret", value: process.env.DOS_REPORTS_MDS_ACCESS_SECRET },
    ])
  })
  .then(() => {
    ps.invoke()
      .then(output => {
        console.log(output)
      })
      .catch(err => {
        console.log(err)
        ps.dispose()
      })
      .finally(() => ps.dispose())
  })
