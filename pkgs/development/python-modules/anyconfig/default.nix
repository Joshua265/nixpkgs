{ buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "anyconfig";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A/8uF2KvOI+7vtHBq3+fHsAGqR2n2zpouWPabneV0qw=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=src -vv" ""
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # OSError: /build/anyconfig-0.12.0/tests/res/cli/no_template/10/e/10.* should exists but not
    "test_runs_for_datasets"
  ];

  disabledTestPaths = [
    # NameError: name 'TT' is not defined
    "tests/schema/test_jsonschema.py"
  ];

  pythonImportsCheck = [ "anyconfig" ];

  meta = with lib; {
    description = "Python library provides common APIs to load and dump configuration files in various formats";
    mainProgram = "anyconfig_cli";
    homepage = "https://github.com/ssato/python-anyconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}
