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
package org.dropframework.mvc.commons
{

    /**
     * Guard proxy which delays all requests to the wrapped object until it's fully created to process the calls.
     *
     * @author jdanilov
     */
    public interface ICreationGuard
    {
        /**
         * Returns true if the guarded object has been created.
         *
         * @result true if the object has been created.
         * */
        function get isObjectCreated () : Boolean;


        /**
         * Calls function f with specified list of arguments once the guarded object is created. Call processed
         * immediately if the guarded object already created.
         *
         * @param f function to be invoked once the guarded object created.
         * @param args array of arguments to be passed to the function. If null, function will be called with no
         * arguments.
         */
        function callOnceCreated (f : Function, args : Array = null) : void;


        /**
         * Cleans delayed calls for the specified function f.
         *
         * @param f function, calls to which to be removed from the delayed calls queue. If null passed all calls will
         * be removed. If object has been created, invoking this method will have no effect as all calls will be
         * processed already.
         * */
        function cleanDelayedCalls (f : Function = null) : void;
    }
}