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
     * Represents a Destroyable object.
     *
     * @author jdanilov
     * */
    public interface IDestroyable
    {
        /**
         * Returns true if the object has been previously destroyed. Object can be destroyed only once per lifecycle.
         * Object is not destroyed at creation time but may be destroyed immediately in it's constructor.
         * */
        function get isDestroyed () : Boolean;


        /**
         * Destroys the object, cleaning all allocated resources. If object has been destroyed already, no action will
         * be taken.
         * */
        function destroy () : void
    }
}