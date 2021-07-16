package runtime.actionContainers

import actionContainers.ActionContainer.withContainer
import actionContainers.{ActionContainer, ActionProxyContainerTestUtils}
import common.WskActorSystem
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import spray.json.{JsonParser,JsObject}
import actionContainers.ResourceHelpers.readAsBase64
import java.io.File

@RunWith(classOf[JUnitRunner])
class SingleTest extends ActionProxyContainerTestUtils with WskActorSystem {
  lazy val imageName = "actionloop-python-v3.7"

  def withActionContainer(env: Map[String, String] = Map.empty)(code: ActionContainer => Unit) = {
    withContainer(imageName, env)(code)
  }

   def testArtifact(name: String): File = {
    new File(this.getClass.getClassLoader.getResource(name).toURI)
  }
  behavior of imageName

  val code =
    """|import sys
       |def main(args):
       |   print("hello stdout", file=sys.stdout)
       |   print("hello stderr", file=sys.stderr)
       |   return args
       |""".stripMargin

  val data = JsonParser("""{"name":"Mike"}""")

  it should "return an echo of the input" in {
    val (out, err) = withActionContainer() { c =>
      val (initCode, _) = c.init(initPayload(code))
      initCode should be(200)
      val (runCode, runRes) = c.run(runPayload(data))
      runCode should be(200)
    }
  }

  it should "run zipped Python action containing a virtual environment" in {
    val zippedPythonAction = testArtifact("python_virtualenv.zip")
    val code = readAsBase64(zippedPythonAction.toPath)

    withActionContainer() { c =>
      val (initCode, initRes) = c.init(initPayload(code))
      initCode should be(200)

      val (runCode, runRes) = c.run(runPayload(JsObject.empty))
      runCode should be(200)
      runRes.get.prettyPrint should include("\"agent\"")
    }
  }

  it should "run zipped Python action containing a virtual environment with non-standard entry point" in {
    val zippedPythonAction = testArtifact("python_virtualenv.zip")
    val code = readAsBase64(zippedPythonAction.toPath)

    withActionContainer() { c =>
      val (initCode, initRes) = c.init(initPayload(code, main = "naim"))
      initCode should be(200)

      val (runCode, runRes) = c.run(runPayload(JsObject.empty))
      runCode should be(200)
      runRes.get.prettyPrint should include("\"agent\"")
    }
  }

}