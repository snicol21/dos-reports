const modules = require("../package.json").pwshDependencies
const shell = require("node-powershell")

let ps = new shell({
  verbose: true,
  executionPolicy: "Unrestricted",
  noProfile: true,
})

ps.addCommand("./scripts/postinstall.ps1")
  .then(() => {
    ps.addParameters([{ name: "modules", value: modules }])
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
