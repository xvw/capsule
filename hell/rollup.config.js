import commonjs from '@rollup/plugin-commonjs';
import noderesolve from '@rollup/plugin-node-resolve';
import babel from '@rollup/plugin-babel';
import terser from '@rollup/plugin-terser';

export default {
    input: 'src/main.js',
    output: {
	file: '_build/hell.js',
	format: 'cjs'
    },
    plugins: [
        commonjs(), 
        noderesolve(),
        babel({ babelHelpers: 'bundled' }), 
        terser()
    ]
};
