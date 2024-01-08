from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    def test_minus_one(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_singlePoint(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([-10])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()


    def test_invalid_n(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([-1, -1, -1, 2, 3, 4, -2, -200, -1000, -22332, 2223, -1314])
        t.input_array("a0", array0)
        t.input_scalar("a1", 0)
        t.call("relu")
        t.check_array(array0, [-1, -1, -1, 2, 3, 4, -2, -200, -1000, -22332, 2223, -1314]) 
        t.execute(code=78)

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple0(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([2, 3, -1, 4, 100, 3])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 4)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_simple1(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-34, 884, -1076, 74, 394])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 1)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_singlePoint(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-1000])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_exception(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-1000, 2000])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", 0)
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 77)
        t.check_array(array0, [-1000, 2000])
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute(code=77)



    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        # raise NotImplementedError("TODO")
        array0 = t.array([1, 2, 3, 4, 5])
        array1 = t.array([5, 4, 3, 2, 1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 35)
        t.execute()

    def test_exception_length(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        # raise NotImplementedError("TODO")
        array0 = t.array([1, 2, 3, 4, 5])
        array1 = t.array([5, 4, 3, 2, 1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=75)

    def test_exception_stride_02(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        # raise NotImplementedError("TODO")
        array0 = t.array([1, 2, 3, 4, 5])
        array1 = t.array([5, 4, 3, 2, 1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=76)

    def test_exception_stride_01(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        # raise NotImplementedError("TODO")
        array0 = t.array([1, 2, 3, 4, 5])
        array1 = t.array([5, 4, 3, 2, 1])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(array0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 0)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=76)

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        #raise NotImplementedError("TODO")
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)

        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)
        # load address of output array
        t.input_array("a6", array_out)
        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)
        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_nmMatrix(self):
        # m0: 3x4 m1: 4x2
        self.do_matmul(
            [2, 3, 4, 5, 1, 2, 10, 20, 2, 3, 22, 10], 3, 4,
            [2, 3, 10, 2, -2, 2, 33, 44], 4, 2,
            [191, 240, 662, 907, 320, 496]
        )

    def test_exception_m0(self):
        t = AssemblyTest(self, "matmul.s")
        t.include("dot.s")
        t.input_scalar("a1", 0)
        t.call("matmul")
        #t.check_scalar("a0", 72)
        t.execute(code=72)

    def test_exception_m1(self):
        t = AssemblyTest(self, "matmul.s")
        t.include("dot.s")
        t.input_scalar("a1", 2)
        t.input_scalar("a2", 3)
        t.input_scalar("a4", 2)
        t.input_scalar("a5", 0)
        t.call("matmul")
        #t.check_scalar("a0", 73)
        t.execute(code=73)

    def test_exception_notMatch(self):
        t = AssemblyTest(self, "matmul.s")
        t.include("dot.s")
        t.input_scalar("a1", 2)
        t.input_scalar("a2", 3)
        t.input_scalar("a4", 2)
        t.input_scalar("a5", 5)
        t.call("matmul")
        #t.check_scalar("a0", 74)
        t.execute(code=74)

    def test_singePoint(self):
        # m0: 3x4 m1: 4x2
        self.do_matmul(
            [2], 1, 1,
            [4], 1, 1,
            [8]
        )



    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def do_read_matrix(self, filename: str, answer, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", filename)

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        # raise NotImplementedError("TODO")
        t.input_array("a1", rows)
        t.input_array("a2", cols)
        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array_pointer("a0", answer)
        # NOTE: the right above will report a warning message
        # t.check_array_pointer("a1", [3])
        # t.check_array_pointer("a2", [3])
        # this is because that we use the value in a1 and a2
        # after function call, violating the calling convention:
        
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9])
    def test_invalid_input01(self):
        self.do_read_matrix("inputs/test_read_matrix/test_invalid_row01.bin", [2, 3, 2, 3, 2, 3, 2, 3], code=91)
    def test_invalid_input02(self):
        self.do_read_matrix("inputs/test_read_matrix/test_invalid_row02.bin", [2, 3, 2, 3, 2, 3, 2, 3], code=91)
    def test_fail_malloc(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9], fail="malloc", code=88)
    def test_fail_fopen(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9], fail="fopen", code=90)
    def test_fail_fread(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9], fail="fread", code=91)
    def test_fail_fclose(self):
        self.do_read_matrix("inputs/test_read_matrix/test_input.bin", [1, 2, 3, 4, 5, 6, 7, 8, 9], fail="fclose", code=92)



    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, fail='', code=0, check=True):
        t = AssemblyTest(self, "write_matrix.s")
        outfile = "outputs/test_write_matrix/student.bin"
        # load output file name into a0 register
        t.input_write_filename("a0", outfile)
        # load input array and other arguments
        #raise NotImplementedError("TODO")
        data = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.input_array("a1", data)
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 3)
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        if check == True:
            t.check_file_output(outfile, "outputs/test_write_matrix/reference.bin")

    def test_simple(self):
        self.do_write_matrix()
    def test_fail_fopen(self):
        self.do_write_matrix(fail="fopen", code=93, check=False)
    def test_fail_fwrite(self):
        self.do_write_matrix(fail="fwrite", code=94, check=False)
    def test_fail_fclose(self):
        self.do_write_matrix(fail="fclose", code=95, check=False)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)

        # compare the output file and
        # raise NotImplementedError("TODO")
        # compare the classification output with `check_stdout`
        t.check_file_output(ref_file, out_file)
    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


class TestMain(TestCase):

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin", f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"
        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args, verbose=False)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")
