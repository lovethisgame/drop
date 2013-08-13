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
package org.dropframework.core.actors
{

    /**
     * Drop Actor marker interface.
     *
     * Only IActor instances can be registered in the Drop Context (IContext interface).
     *
     * Designed to be extended by custom system actor types, for instance Mediator, Model, Business, etc. defining
     * the areas of responsibility (Concerns) in the system.
     *
     * @author jdanilov
     * */
    public interface IActor
    {
        // implementations may provide specific methods
    }
}