package runtime.actionContainers
import spray.json.JsObject

trait PythonActionLoopExtraTests {
  this : PythonActionContainerTests =>

  it should "detect termination at run" in {
    val (out, err) = withActionContainer() { c =>
      val code =
        """
          |import sys
          |def main(args):
          |  sys.exit(1)
        """.stripMargin

      // action loop detects those errors at init time
      val (initCode, _) = c.init(initPayload(code))
      initCode should be(200)

      val (runCode, runRes) = c.run(runPayload(JsObject()))
      runCode should be(400)
      println(runCode, runRes)
      runRes.get.fields.get("error").get.toString() should include("command exited")
    }
    checkStreams(out, err, {
      case (o, e) =>
        o shouldBe empty
        e shouldBe empty
    })
  }

  it should "detect termination at init" in {
    val (out, err) = withActionContainer() { c =>
      val code =
        """
          |import sys
          |sys.exit(1)
          |def main(args):
          |   pass
        """.stripMargin

      // action loop detects those errors at init time
      val (initCode, initRes) = c.init(initPayload(code))
      initCode should be(502)
      initRes.get.fields.get("error").get.toString() should include("Cannot start action")
    }
    checkStreams(out, err, {
      case (o, e) =>
        o shouldBe empty
        e should include("command exited before ack")
    })
  }

  it should "read an environment variable" in {
    val (out, err) = withActionContainer(Map("X"->"xyz")) { c =>
      val code = """
                   |import os
                   |X = os.getenv('X')
                   |print(X)
                   |def main(args):
                   |   return { "body": "ok" }
                 """.stripMargin

      // action loop detects those errors at init time
      val (initCode, initRes) = c.init(initPayload(code))
      initCode should be(200)

      val (runCode, runRes) = c.run(runPayload(JsObject()))
      runCode should be(200)
    }
    checkStreams(out, err, {
      case (o, e) =>
        o shouldBe include("xyz")
        e shouldBe empty
    })
  }
}
