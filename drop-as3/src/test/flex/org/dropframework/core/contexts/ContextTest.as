/*
 * Copyright 2013 Drop Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.dropframework.core.contexts
{

    import org.flexunit.asserts.*;


    public class ContextTest
    {
        private var context : IContext;


        [Before]
        public function beforeTest() : void
        {
            context = new Context();
            // todo: pre-initialize context with some actors
        }

        [After]
        public function afterTest() : void
        {
            context = null;
        }


        [Test]
        public function testRegister() : void
        {
            // todo: add tests
        }


        [Test]
        public function testRemove() : void
        {
            // todo: add tests
        }


        [Test]
        public function testInstanceOf() : void
        {
            // todo: add tests
        }


        [Test]
        public function testCall() : void
        {
            // todo: add tests
        }
    }
}
