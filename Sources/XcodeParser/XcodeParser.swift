import XcodeProj
import PathKit

public class XcodeParser {
  public init(path: String) throws {
    let project = try XcodeProj(path: Path(path))
  }
}
