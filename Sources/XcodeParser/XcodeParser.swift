import PathKit
import XcodeProj

public class XcodeParser {
  let project: XcodeProj
  public init(path: String) throws {
    project = try XcodeProj(path: Path(path))
  }
}
